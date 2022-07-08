$(document).ready(function(){
	
    $('#imtech').on("click",function(e){
       
		e.preventDefault();
        
		$('#ImtechDetails').parse({
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
