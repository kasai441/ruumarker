/**
 * @jest-environment jsdom
 */
/* eslint-env jest */

// import { mount } from '@vue/test-utils'
// import ImageUpload from '../app/javascript/components/image_upload.vue'

// const event = {
//   target: {
//     files: [
//       {
//         name: 'image.png',
//         size: 50000,
//         type: 'image/png',
//       },
//     ],
//   },
//   preventDefault: () => {}
// }

describe('ImageUpload', () => {
  it('画像アップロード時に画像を持続させるための呼び出しを行う', () => {
    // const wrapper = mount(ImageUpload)
    // const fileReaderSpy = jest.spyOn(FileReader.prototype, 'readAsDataURL').mockImplementation(() => null)
    // const result = wrapper.vm.upload(event)
    // console.log(result)
    // expect(fileReaderSpy).toHaveBeenCalledWith(event.target.files[0])
  })
})
