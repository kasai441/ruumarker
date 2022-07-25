import params from './params'

const parent = (tagName, element, className) => {
  if (element.nodeName === 'BODY') return
  const conditions =
    element.nodeName === tagName ||
    element.classList.value.includes(className)
  return conditions ? element : parent(tagName, element.parentElement, className)
}

const generateLocators = (locators, options) => {
  const elements = []
  locators.forEach((locator, index) => {
    if (options && options.except == locator.id) return

    let src = '/locators.png'
    if (options && options.editMode) src = '/locators_grey.png'
    if (options && options.printMode) src = '/locators_white.png'

    const img = document.createElement('img')
    const zIndex = (!options || options.printMode || !options.indexMode) ? 'z-0' : 'z-10'
    img.classList.add('absolute', zIndex, 'w-7', 'h-7', 'pointer-events-none')
    img.src = src

    const number = document.createElement('a')
    number.classList.add('relative', zIndex, 'text-sm', 'pointer-events-none')
    if (!options || !options.printMode) number.classList.add('text-white')
    number.append(index + 1)

    const a = document.createElement('a')
    if (!options || !options.indexMode) a.id = `locator-${locator.id}`
    a.classList.add('absolute', 'w-7', 'h-7', 'flex', 'justify-center', 'items-center')
    if (options && options.class) a.classList.add(...options.class)
    a.append(img, number)

    elements.push(a)
  })
  return elements
}

const layoutLocators = (locators, id) => {
  const element = document.getElementById(id)
  if (!element) return

  const image = {
    w: element.style.width.replace('px', ''),
    h: element.style.height.replace('px', ''),
    left: Number(element.style.left.replace('px', '')),
    top: Number(element.style.top.replace('px', ''))
  }
  locators.forEach(locator => {
    const a = document.getElementById(`locator-${locator.id}`)
    if (!a) return

    const locationRate = params.parseOrInit(locator.location)
    const locatorLocationX = image.w * (0.5 - locationRate.x)
    const locatorLocationY = image.h * (0.5 - locationRate.y)
    const radius = 14
    a.style.left = image.left + locatorLocationX - radius + 'px'
    a.style.top = image.top + locatorLocationY - radius + 'px'
  })
}

const expand = (fieldSize, formData, imageId, element) => {
  if (!fieldSize) return

  const target = formData.get('target')
  const expansion = formData.get(`${target}[expansion]`) || 100
  writeSize(imageId, {
    w: fieldSize.w * expansion / 100,
    h: fieldSize.h * expansion / 100
  }, element)
}

const trim = (fieldSize, formData, imageId, element) => {
  if (!fieldSize) return

  const target = formData.get('target')
  const trimmingRate = params.parseOrInit(formData.get(`${target}[trimming]`))
  const trimming = params.toPixel(fieldSize, trimmingRate)
  const expansion = formData.get(`${target}[expansion]`) || 100
  writePosition(imageId, {
    x: trimming.x - fieldSize.w * (expansion / 100 - 1) / 2,
    y: trimming.y - fieldSize.h * (expansion / 100 - 1) / 2
  }, element)
  return trimming
}

const locate = (fieldSize, locatorFormData, fieldFormData, imageId) => {
  const locatorTarget = locatorFormData.get('target')
  const locationRate = params.parseOrInit(locatorFormData.get(`${locatorTarget}[location]`))
  const imageSize = readSize(imageId)
  const fieldTarget = fieldFormData.get('target')
  const expansion = fieldFormData.get(`${fieldTarget}[expansion]`) || 100
  let location = params.toPixel(imageSize, locationRate)
  location.x -= fieldSize.w * (expansion / 100 - 1) / 2
  location.y -= fieldSize.h * (expansion / 100 - 1) / 2
  writePosition(imageId, location)
  return location
}

const offset = (fieldSize, formData, location) => {
  const target = formData.get('target')
  const trimmingRate = params.parseOrInit(formData.get(`${target}[trimming]`))
  const trimming = params.toPixel(fieldSize, trimmingRate)
  const expansion = formData.get(`${target}[expansion]`) || 100
  return {
    x: location.x + fieldSize.w * (expansion / 100 - 1) / 2 - trimming.x,
    y: location.y + fieldSize.h * (expansion / 100 - 1) / 2 - trimming.y
  }
}

const readSize = (id, element) => {
  element ||= document.getElementById(id)
  if (!element) return

  const left = element.getBoundingClientRect().left
  const top = element.getBoundingClientRect().top
  return {
    w: element.getBoundingClientRect().right - left,
    h: element.getBoundingClientRect().bottom - top
  }
}

const writeSize = (id, value, element) => {
  element ||= document.getElementById(id)
  element.style.width = value.w + 'px'
  element.style.height = value.h + 'px'
}

const writePosition = (id, value, element) => {
  element ||= document.getElementById(id)
  element.style.left = value.x + 'px'
  element.style.top = value.y + 'px'
}

const loadingFilter = isLoading => {
  const loadingFilter = document.getElementById('loading-filter')
  if (isLoading) {
    loadingFilter.classList.remove('hidden')
  } else {
    loadingFilter.classList.add('hidden')
  }
}

const homeTop = () => {
  const homeTop = document.getElementById('home-top')
  if (!homeTop) return

  homeTop.addEventListener('click', () => {
    window.scrollTo({
      behavior: 'smooth',
      left: 0,
      top: 0
    })
  })
}

const displayHome = () => {
  const home = document.getElementById('home')
  home.classList.remove('hidden')
}

const displayHelp = () => {
  const help = document.getElementById('help')
  help.classList.remove('hidden')
  help.addEventListener('click', () => {
    help.classList.add('animate-fadeout')
    location.href = '/help'
  })
}

const browserBack = () => {
  const fadeouts = document.getElementsByClassName('animate-fadeout')
  Array.prototype.forEach.call(fadeouts, fadeout => {
    fadeout.classList.remove('animate-fadeout')
  })

  const selects = document.getElementsByClassName('animate-select')
  Array.prototype.forEach.call(selects, select => {
    select.classList.remove('animate-select')
  })
}

export default {
  namespaced: true,
  parent,
  generateLocators,
  layoutLocators,
  expand,
  trim,
  locate,
  offset,
  readSize,
  writeSize,
  writePosition,
  loadingFilter,
  homeTop,
  displayHome,
  displayHelp,
  browserBack
}
