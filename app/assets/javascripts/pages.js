

var makerequest = function () {
  var url = "/request";
  var divinput = document.querySelector( "input" );

  if( divinput.value != "" ) {
    $.ajax( {
      url: url,
      method: "GET",
      dataType: "JSON",
      data: {
        "q": divinput.value
      },
      success: function ( data ) {
        var response = $( "<div></div>" ).html( JSON.stringify( data ) );
        $( "#wit_output" ).prepend( response );
      }
    } ).done( function ( data ) {
      // Notify request successfully sent
      console.log( "Request sent" );
    } );
    
  } else {
    alert( "No message being input" );
  }

};

$( document ).ready( function () {
  $( "button" ).on( "click", makerequest );
});
