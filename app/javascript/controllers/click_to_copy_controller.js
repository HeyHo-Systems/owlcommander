import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static values = {
        copied: {type: String, default:''},
        confirmation: {type: String, default: 'Value has been copied to clipboard'},
    }

    onClick(e){
        try{
            console.log(this.copiedValue)
            navigator.clipboard.writeText(this.copiedValue)
            toast(this.confirmationValue)
        }catch(e){
            toast(e.message)
        }

    } 

    connect() {
        this.boundOnClick = this.onClick.bind(this)
        this.element.addEventListener('click', this.boundOnClick)
    }

    disconnect() {
        this.element.removeEventListener('click', this.boundOnClick)
    }
}


function toast(text,duration=2000) {
    const div=document.createElement('div')
    Object.assign(div.style,{background:'black', color:'white', opacity:0.8, position:'fixed', left:'50%', bottom:'20px',padding:'10px 20px',borderRadius:'20px',lineHeight:'20px',transform:'translate(-50%,0)', fontWeight:'bold'})
    div.textContent=text
    document.body.appendChild(div)
    setTimeout(()=>div.parentElement.removeChild(div), duration)
}
