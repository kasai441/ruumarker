import params from './params'

const parent = (name, elem) => {
  if (elem.nodeName === 'BODY') return

  return elem.nodeName === name ? elem : parent(name, elem.parentElement)
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

const transferLocators = (locators, fieldLocation, id) => {
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
    // console.log('fieldLocation.x + locatorLocationX')
    // console.log(fieldLocation.x, locatorLocationX)
    a.style.left = image.left + locatorLocationX - radius + 'px'
    a.style.top = image.top + locatorLocationY - radius + 'px'
  })
}

const field = (id, element) => {
  element ||= document.getElementById(id)
  const left = params.toF(element.getBoundingClientRect().left, 1)
  const top = params.toF(element.getBoundingClientRect().top, 1)
  return {
    w: params.toF(element.getBoundingClientRect().right, 1) - left,
    h: params.toF(element.getBoundingClientRect().bottom, 1) - top
  }
}

const styleLeftTop = (id, value, element) => {
  element ||= document.getElementById(id)
  element.style.left = value.x + 'px'
  element.style.top = value.y + 'px'
}

export default {
  namespaced: true,
  parent,
  generateLocators,
  generateElement,
  transferLocators,
  field,
  styleLeftTop
}
