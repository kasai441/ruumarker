/**
 * @jest-environment jsdom
 */
/* eslint-env jest */

import { mount } from '@vue/test-utils'
import ImageUpload from '../app/javascript/components/image_upload.vue'

const event = {
  target: {
    files: [
      {
        name: 'image.png',
        size: 50000,
        type: 'image/png',
      },
    ],
  },
  preventDefault: () => {}
}

describe('ImageUpload', () => {
  it('makes a call to persist the image on image upload', () => {
    const wrapper = mount(ImageUpload)
    const fileReaderSpy = jest.spyOn(FileReader.prototype, 'readAsDataURL').mockImplementation(() => null)
    wrapper.vm.upload(event)

    expect(fileReaderSpy).toHaveBeenCalledWith(event.target.files[0])
  })
})
