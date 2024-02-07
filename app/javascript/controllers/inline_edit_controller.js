import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source", "form", "input", "button" ]

  connect() {
    this.model        = this.data.get("model")        || "model"
    this.name         = this.data.get("name")         || "name"
    this.update_path  = this.data.get("update-path")  || undefined
    this.input_class  = this.data.get("input-class")  || "input"
  }

  edit() {
    if (!this.update_path) {
        // we can't update if we don't know where to post the form
        console.warn("Can't update without update_path")
        return;
    }
    if (!(this.data.get("editing") == 1)) {
      this.data.set("original_value", this.sourceTarget.innerHTML)
      this.sourceTarget.innerHTML = this.form()
      this.inputTarget.focus()
      this.data.set("editing", 1)
      this.pauseRefresh()
    }
  }

  cancel(event) {
    event.stopPropagation()
    if (this.data.get("editing") == 1) {
      this.data.set("editing", 0)
      this.sourceTarget.innerHTML = this.data.get("original_value")
      this.resumeRefresh()
    }
  }

  save() {
    if (this.data.get("editing") == 1) {
      this.submit()
      this.buttonTarget.innerHTML = this.spinner()
      this.buttonTarget.disabled = true
      this.inputTarget.disabled = true
    }
  }

  submit() {
    this.formTarget.requestSubmit()
    this.resumeRefresh()
  }

  form() {
    const form = `
      <form action="${this.update_path}" accept-charset="UTF-8" data-remote="true" data-inline-edit-target="form" method="post">
        <input name="utf8" type="hidden" value="✓">
        <input type="hidden" name="_method" value="patch">
        <input type="hidden" name="authenticity_token" value="${this.authenticity_token}">
        <div class="flex flex-row relative">
          <div class="absolute top-0 -left-12">
            <button type="button" class="bg-red-400 p-1.5 mt-1 rounded-full text-xs text-white" class="cursor-pointer" data-action="click->inline-edit#cancel">${this.undo()}</button>
          </div>
          <div class="basis-3/4">
            <input type="text" autofocus value="${this.input_value}" name="${this.model}[${this.name}]" class="${this.input_class}" id="${this.model}_${this.name}" data-inline-edit-target="input">
          </div>
          <div class="basis-1/4">
            <button type="button" class="bg-teal-400 p-1.5 mt-1 rounded-full text-xs text-white" class="cursor-pointer" data-action="click->inline-edit#save" data-inline-edit-target="button">${this.check()}</button>
          </div>
        </div>
      </form>
    `
    return form
  }

  pauseRefresh() {
    const event = new Event('search:pauseRefresh')
    document.dispatchEvent(event)
  }

  resumeRefresh() {
    const event = new Event('search:resumeRefresh')
    document.dispatchEvent(event)
  }

  check() {
    const icon = `
      <svg xmlns="http://www.w3.org/2000/svg" class="stroke-white" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
    `
    return icon
  }

  spinner() {
    const icon = `
      <svg xmlns="http://www.w3.org/2000/svg" class="stroke-white animate-spin" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="2" x2="12" y2="6"></line><line x1="12" y1="18" x2="12" y2="22"></line><line x1="4.93" y1="4.93" x2="7.76" y2="7.76"></line><line x1="16.24" y1="16.24" x2="19.07" y2="19.07"></line><line x1="2" y1="12" x2="6" y2="12"></line><line x1="18" y1="12" x2="22" y2="12"></line><line x1="4.93" y1="19.07" x2="7.76" y2="16.24"></line><line x1="16.24" y1="7.76" x2="19.07" y2="4.93"></line></svg>
    `
    return icon
  }

  undo() {
    const icon = `
      <svg xmlns="http://www.w3.org/2000/svg" class="stroke-white" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2.5 2v6h6M2.66 15.57a10 10 0 1 0 .57-8.38"/></svg>
    `
    return icon
  }

  get input_value() {
    return this.sourceTarget.dataset.inlineEditValue
  }

  get authenticity_token() {
    return document.querySelector("meta[name='csrf-token']").getAttribute("content");
  }
}
