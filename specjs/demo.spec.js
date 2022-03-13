/* eslint-env jest */

import { mount } from '@vue/test-utils'
import Mark from '../app/javascript/mark.vue'

test('renders a todo', () => {
  const wrapper = mount(Mark)

  const todo = wrapper.get('[data-test="todo"]')

  expect(todo.text()).toBe('Learn Vue.js 3')
})
