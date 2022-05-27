const parentTr = element => {
  if (element.nodeName === 'BODY') return null

  if (element.parentElement.nodeName === 'TR') {
    return element.parentElement
  } else {
    return parentTr(element.parentElement)
  }
}

export default {
  namespaced: true,
  parentTr
}
