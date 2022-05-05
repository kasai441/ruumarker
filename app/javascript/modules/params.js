const trimming = (formData) => {
  try {
    return JSON.parse(formData.get('map[trimming]'))
  } catch {
    return {x: 0, y: 0}
  }
}

const readImageUrl = (uploadedTag, imageFile) => {
  const reader = new FileReader()
  reader.onload = function () {
    uploadedTag.src = this.result
  }
  reader.readAsDataURL(imageFile)
}

export default {
  namespaced: true,
  trimming,
  readImageUrl
}
