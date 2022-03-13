/* eslint-env mocha */

import { shallowMount } from '@vue/test-utils'
import Mark from '../app/javascript/mark.vue'

describe('Mark.vue', () => {
  it('キズを追加できる', () => {
    const wrapper = shallowMount(Mark)
    wrapper.find('button').trigger('click')
    expect(wrapper.find('div').text()).toMatch('1')
  })
})
