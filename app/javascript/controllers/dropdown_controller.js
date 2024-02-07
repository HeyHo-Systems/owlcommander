import { Controller } from '@hotwired/stimulus' 

export default class extends Controller {
  static targets = ['menu', 'button']
  open=false
  lastClick=0;

  hide() { 
    if(this.open)
      setTimeout(()=>{ 
        if(Date.now()-this.lastClick>100){
          console.log('hide', this)
          this.open = false
          this.refresh()
        }
      })
  }

  toggle() {
    this.lastClick=Date.now()
    console.log('toggle', this)
    this.open = !this.open
    this.refresh()
  }
 
  refresh(){
    if(this.open){
      this.menuTarget.classList.remove('hidden')
      document.dispatchEvent(new Event('search:pauseRefresh'))
    }else{
      this.menuTarget.classList.add('hidden')
      document.dispatchEvent(new Event('search:resumeRefresh'))

    } 
  }
 

}