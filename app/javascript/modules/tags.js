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
    const locatorLocationX = Math.floor(field.w * (0.5 - locationRate.x))
    const locatorLocationY = Math.floor(field.h * (0.5 - locationRate.y))
    const r = 10
    a.style.left = fieldLocation.x + locatorLocationX - r + 'px'
    a.style.top = fieldLocation.y + locatorLocationY - r + 'px'
  })
}

const field = id => {
  const field = document.getElementById(id)
  const left = Math.floor(field.getBoundingClientRect().left)
  const top = Math.floor(field.getBoundingClientRect().top)
  return {
    w: Math.floor(field.getBoundingClientRect().right) - left,
    h: Math.floor(field.getBoundingClientRect().bottom) - top
  }
}

export default {
  namespaced: true,
  parent,
  generateLocators,
  transferLocators,
  field
}
