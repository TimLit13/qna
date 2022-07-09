$(document).on('turbolinks:load', function(){
    $('.rating').on('ajax:success', displayRating)
    .on('page:update', displayRating)
    .on('ajax:error', displayErrors)
})

function displayRating(event) {
    let resourceId = event.detail[0].resource_id
    let status = event.detail[0].status
    if (status === 'unprocessable_entity') { 
        displayErrors(event)
    } else {
        let resourceName = event.detail[0].resource_name
        let rating = event.detail[0].rating
        let ratedBefore = event.detail[0].rated_before
        let ratingTagName = '#' + resourceName + '-id-' + resourceId + '-rating'
        $(ratingTagName + '> .rating-value').html(rating)
        
        if (ratedBefore === 'true') {
            $(ratingTagName + '> .cancel-rate').removeClass('hidden')
            $(ratingTagName + '> .rate-up').addClass('hidden')
            $(ratingTagName + '> .rate-down').addClass('hidden')
        } else {
            $(ratingTagName + '> .cancel-rate').addClass('hidden')
            $(ratingTagName + '> .rate-up').removeClass('hidden')
            $(ratingTagName + '> .rate-down').removeClass('hidden')       
        }
    }
} 

function displayErrors(event) {
    let errors = event.detail[0].error
    let errorsList = document.createElement('ul')
    $('.alert').html('').append(errorsList)
    if ($.isArray(errors)) {
        $.each(errors, function(index, value){
            let liElement = document.createElement('li')
            liElement.append(value)
            errorsList.append(liElement)
        })
    } else {
        let liElement = document.createElement('li')
            liElement.append(errors)
            errorsList.append(liElement)
    }
}
