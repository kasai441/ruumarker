const parent = (name, elem) => {
  if (elem.nodeName === 'BODY') return

  return elem.nodeName === name ? elem : parent(name, elem.parentElement)
}

const generateLocators = (locators, field, options) => {
  locators.forEach((locator, index) => {
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

export default {
  namespaced: true,
  parent,
  generateLocators
}
