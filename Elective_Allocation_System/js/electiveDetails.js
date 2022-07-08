$(document).ready(function(){
	
    $('#upbtn2').on("click",function(e){
       
		e.preventDefault();
        
		$('#electiveDetails').parse({
			config: {
				delimiter: "",
                header:false,
				complete: printDetails,
			},
			before: function(file, inputElem)
			{
       			console.log("Parsing file...", file);
			},
			error: function(err, file)
			{
        		console.log("ERROR:", err, file);
			},
			complete: function()
			{
                $('#upbtn2').prop('disabled', true);
                $('#upbtn2').prop('value', 'Uploded');
				console.log("Done with all files");
			}
		});
    });

	function printDetails(result){

		var data = result.data;

		for(var i=0; i<data.length; i++) {
			console.table(data[i]);
		}
	}
});
