// app/javascript/controllers/toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "edit"]

  toggle() {
    this.contentTarget.classList.toggle("hidden")
    this.editTarget.classList.toggle("hidden")
  }
}
