let setIndividualLikeButton = (event: Event) => {
  let div = <HTMLElement>event.currentTarget;

  let anchor = <HTMLElement>div.firstElementChild;
  let icon = <HTMLElement>anchor.childNodes[0];
  let likeFlash = <HTMLElement>anchor.childNodes[1];
  let outerLatestLikedTime = <HTMLElement>anchor.childNodes[2];
  // let likeNumElement = <HTMLElement>anchor.childNodes[1];
  anchor.classList.toggle('liked');

  if (icon.classList.contains('bi-heart-fill')) {
    icon.classList.replace('bi-heart-fill', 'bi-heart');
    anchor.setAttribute('data-method', 'post');
    outerLatestLikedTime.classList.remove('d-none');
    likeFlash.innerText = '';
  } else {
    icon.classList.replace('bi-heart', 'bi-heart-fill');
    anchor.setAttribute('data-method', 'delete');
    likeFlash.innerText = "「いいね」しました！";
    outerLatestLikedTime.classList.add('d-none');
  }
}

export function setLikeButtons() {
  document.querySelectorAll('.like-btn-wrapper').forEach(function (div) {
    div.addEventListener('ajax:success', setIndividualLikeButton);
  });
};
