import params from './params'

const parent = (tagName, element, className) => {
  if (element.nodeName === 'BODY') return
  const conditions =
    element.nodeName === tagName ||
    element.classList.value.includes(className)
  return conditions ? element : parent(tagName, element.parentElement, className)
}

const generateLocators = (locators, id, options) => {
  locators.forEach((locator, index) => {
    if (options && options.except == locator.id) return

    let src = '/locators.png'
    if (options && options.editMode) src = '/locators_grey.png'
    if (options && options.printMode) src = '/locators_white.png'
    const img = generateElement('img', {
      class: ['absolute', 'w-5', 'pointer-events-none'],
      src
    })

    const number = generateElement('a', {
      class: options && options.printMode ?
        ['relative', 'text-sm', 'pointer-events-none'] :
        ['relative', 'text-white', 'text-sm', 'pointer-events-none'],
      append: [index + 1]
    })

    let classA = ['absolute', 'w-5', 'flex', 'justify-center', 'items-center']
    if (options && options.class) classA = classA.concat(options.class)

    const a = generateElement('a',{
      id: `locator-${locator.id}`,
      class: classA,
      append: [img, number]
    })

    document.getElementById(id).append(a)
  })
}

const generateElement = (tagName, options) => {
  const element = document.createElement(tagName)
  if (!options) return element

  if (options.id) {
    element.id = options.id
  }
  if (options.class) {
    options.class.forEach(cl => element.classList.add(cl))
  }
  if (options.append) {
    options.append.forEach(ap => element.append(ap))
  }
  if (options.src) {
    element.src = options.src
  }
  return element
}

const layoutLocators = (locators, id) => {
  const element = document.getElementById(id)
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
    const locatorLocationX = params.toF(image.w * (0.5 - locationRate.x), 1)
    const locatorLocationY = params.toF(image.h * (0.5 - locationRate.y), 1)
    const radius = 10
    a.style.left = image.left + locatorLocationX - radius + 'px'
    a.style.top = image.top + locatorLocationY - radius + 'px'
  })
}

const expand = (fieldSize, formData, imageId, element) => {
  const target = formData.get('target')
  const expansion = formData.get(`${target}[expansion]`) || 100
  writeSize(imageId, {
    w: fieldSize.w * expansion / 100,
    h: fieldSize.h * expansion / 100
  }, element)
}

const expandCanvas = async (fieldSize, formData, imageUrl) => {
  const target = formData.get('target')
  const expansion = formData.get(`${target}[expansion]`) || 100
  const imageSize = {
    w: fieldSize.w * expansion / 100,
    h: fieldSize.h * expansion / 100
  }
  console.log(imageSize)
  const imageFile = await params.showImage(imageUrl, null, imageSize)
  return await params.getImageUrl(imageFile)
}

const trim = (fieldSize, formData, imageId, element) => {
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
  const left = params.toF(element.getBoundingClientRect().left, 1)
  const top = params.toF(element.getBoundingClientRect().top, 1)
  return {
    w: params.toF(element.getBoundingClientRect().right, 1) - left,
    h: params.toF(element.getBoundingClientRect().bottom, 1) - top
  }
}

const writeSize = (id, value, element) => {
  element ||= document.getElementById(id)
  element.style.width = Math.floor(value.w) + 'px'
  element.style.height = Math.floor(value.h) + 'px'
}

const writePosition = (id, value, element) => {
  element ||= document.getElementById(id)
  element.style.left = Math.floor(value.x) + 'px'
  element.style.top = Math.floor(value.y) + 'px'
}

export default {
  namespaced: true,
  parent,
  generateLocators,
  generateElement,
  layoutLocators,
  expand,
  expandCanvas,
  trim,
  locate,
  offset,
  readSize,
  writeSize,
  writePosition
}
