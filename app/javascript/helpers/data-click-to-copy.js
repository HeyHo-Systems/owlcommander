
// Click to copy interraction
function clearToast(){
    document.getElementById('copied-toast')?.remove()
    document.querySelector('*[data-click-to-copy].copied')?.classList.remove('copied')

}
document.addEventListener('scroll',clearToast)
document.addEventListener('click', (e) =>{
    clearToast()
    if(e.target.hasAttribute('data-click-to-copy')){
        e.preventDefault();
        e.stopPropagation()
        try {
            navigator.clipboard.writeText(e.target.textContent)
            const toast=document.createElement('div')
            toast.innerText="copied"
            toast.id="copied-toast"
            toast.classList.add('toast-after-copy')
            const {left, top, width, height} = e.target.getBoundingClientRect()
            Object.assign(toast.style, {
                left:left+'px',top:top+height+'px', width:width+'px'
            })
            document.body.appendChild(toast)
            e.target.classList.add('copied')
            setTimeout(clearToast, 3000)
        }catch (e){
            alert(`Your browser doesn't seem to support copy events : ${e.message}` )
        }
    }
}, true)

