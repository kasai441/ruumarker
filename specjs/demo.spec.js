/**
 * @jest-environment jsdom
 */
/* eslint-env jest */

import { mount } from '@vue/test-utils'
import Demo from '../app/javascript/demo.vue'

test('renders a todo', () => {
  const wrapper = mount(Demo)

  const todo = wrapper.get('[data-test="todo"]')

  expect(todo.text()).toBe('Learn Vue.js 3')
})
