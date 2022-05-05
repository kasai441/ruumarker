const trimming = (formData, targetModel) => {
  let trimming = JSON.parse(formData.get(`${targetModel}[trimming]`))
  return trimming ||= {x: 0, y: 0}
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
