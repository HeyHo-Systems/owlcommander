
// Reacting to links click is too slow sometimes, so setting the search this way works best
document.addEventListener('click', (e) =>{
    if(e.target.getAttribute('data-link-to-search')){
        e.preventDefault();
        e.stopPropagation()
       document.getElementById('search_search_all').value= e.target.getAttribute('data-link-to-search')
        document.getElementById('submitbtn').click()
    }
}, true)

