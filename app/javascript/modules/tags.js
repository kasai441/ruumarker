import params from './params'

const parent = (name, elem) => {
  if (elem.nodeName === 'BODY') return

  return elem.nodeName === name ? elem : parent(name, elem.parentElement)
}

const generateLocators = (locators, id, options) => {
  locators.forEach((locator, index) => {
    if (options && options.except == locator.id) return

    const img = generateElement('img', {
      class: ['absolute', 'w-5', 'pointer-events-none'],
      src: '/locators.png'
    })
    const number = generateElement('a', {
      class: ['relative', 'text-white', 'text-sm', 'pointer-events-none'],
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

const transferLocators = (locators, fieldLocation, field) => {
  locators.forEach(locator => {
    const a = document.getElementById(`locator-${locator.id}`)
    if (!a) return

    const locationRate = params.parseOrInit(locator.location)
    const locatorLocationX = params.toF(field.w * (0.5 - locationRate.x), 1)
    const locatorLocationY = params.toF(field.h * (0.5 - locationRate.y), 1)
    const radius = 10
    a.style.left = fieldLocation.x + locatorLocationX - radius + 'px'
    a.style.top = fieldLocation.y + locatorLocationY - radius + 'px'
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
