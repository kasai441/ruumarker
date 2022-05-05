const trimming = (formData) => {
  try {
    return JSON.parse(formData.get('map[trimming]'))
  } catch {
    return {x: 0, y: 0}
  }
}

const onloadImage = (formData) => {
  return formData
}

export default {
  namespaced: true,
  trimming,
  onloadImage
}
