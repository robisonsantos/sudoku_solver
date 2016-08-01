$(document).ready(function() {
  $("#retry_action").hide();

  $("input[type='text'").bind("input propertychange", function() {
    if (/^[1-9]{1}$/.test($(this).val()) === false) {
      $(this).val("");
    }
  });

  $("#solve").click(function() {
    var sudoku_hints = [];

    for(row = 0; row < 9; row++) {
      var hint_line = []
      for(col = 0; col < 9; col++) {
        var input_id = "#val_" + row + "_" + col;
        var input_value = $(input_id).val();
        hint_line.push( input_value === "" ? 0 : parseInt(input_value) );
      }
      sudoku_hints.push(hint_line);
    }

    $.ajax({
      url: "/solution",
      method: "POST",
      data: { "hints" : sudoku_hints },
      error: function(xhr, status, error) {
        alert("We got an error. " + status + " " + error);
      },
      success: function(data) {
        $("#sudoku").html(data);
        $("#retry_action").show();
        $("#solve_action").hide();
      }
    });
  });


  $("#clear").click(function() {
    for(row = 0; row < 9; row++) {
      var hint_line = []
      for(col = 0; col < 9; col++) {
        var input_id = "#val_" + row + "_" + col;
        $(input_id).val("");
      }
    }
  });


  $("#retry").click(function() {
    location.reload();
  });

});
