$(document).ready(displayGist);
$(document).on('page:update',displayGist);
$(document).on('turbolinks:load', displayGist);
$(document).on('ajax:success', displayGist);

function displayGist() {
    $('.gist').each(function() {
        let href = $(this).attr('href');
        let gistId = $(this).data('gistId');
        let oneGist = new Gh3.Gist({id:gistId});

        oneGist.fetchContents(function (err, res) {

            if(err) {
                throw "outch ... Can't load gist";
            }

            let gistFiles = oneGist.files;
            let gistFileName = gistFiles[0].filename;
            let gistContent = gistFiles[0].content;

           $('*[data-gist-id=' + gistId + ']').replaceWith(makeTagWithGist(gistFileName, gistContent, href, gistId));
        });
    });
}

function makeTagWithGist(gistFileName, gistContent, href, gistId) {
    let tagWithGistLink = document.createElement('a');
    tagWithGistLink.innerHTML = gistFileName;
    tagWithGistLink.setAttribute('href', href);

    let tagSeparator = document.createElement('p');

    let tagWithGistContent = document.createElement('p');
    tagWithGistContent.innerHTML = gistContent;

    let tagWithGist = document.createElement('div');
    tagWithGist.className = 'updated-gist';
    tagWithGist.setAttribute('data-gist-id', gistId);
    tagWithGist.appendChild(tagWithGistContent);
    tagWithGist.appendChild(tagSeparator);
    tagWithGist.appendChild(tagWithGistLink);
    return tagWithGist;
}
