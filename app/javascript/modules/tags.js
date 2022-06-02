import params from './params'

const parent = (name, elem) => {
  if (elem.nodeName === 'BODY') return

  return elem.nodeName === name ? elem : parent(name, elem.parentElement)
}

const generateLocators = (locators, field, options) => {
  locators.forEach((locator, index) => {
    if (options && options.except == locator.id) return

    const img = document.createElement('img')
    img.src = '/locators.png'
    img.classList.add('absolute', 'w-5', 'pointer-events-none')

    const number = document.createElement('a')
    number.append(index + 1)
    number.classList.add('relative', 'text-white', 'text-sm', 'pointer-events-none')

    const a = document.createElement('a')
    a.append(img)
    a.append(number)
    a.classList.add('absolute', 'w-5', 'flex', 'justify-center', 'items-center')
    a.id = `locator-${locator.id}`

    if (options && options.class) {
      options.class.forEach(c => a.classList.add(c))
    }

    field.append(a)
  })
}

const transferLocators = (locators, fieldLocation, field) => {
  locators.forEach(locator => {
    const a = document.getElementById(`locator-${locator.id}`)
    if (!a) return

    const locationRate = params.parseOrInit(locator.location)
    const locatorLocationX = params.toF(field.w * (0.5 - locationRate.x), 1)
    const locatorLocationY = params.toF(field.h * (0.5 - locationRate.y), 1)
    const r = 10
    a.style.left = fieldLocation.x + locatorLocationX - r + 'px'
    a.style.top = fieldLocation.y + locatorLocationY - r + 'px'
  })
}

const field = id => {
  const field = document.getElementById(id)
  const left = params.toF(field.getBoundingClientRect().left, 1)
  const top = params.toF(field.getBoundingClientRect().top, 1)
  return {
    w: params.toF(field.getBoundingClientRect().right, 1) - left,
    h: params.toF(field.getBoundingClientRect().bottom, 1) - top
  }
}

export default {
  namespaced: true,
  parent,
  generateLocators,
  transferLocators,
  field
}
