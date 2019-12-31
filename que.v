module binue(
	input clk,
	input syn,
	input in,

	output out
    );

reg reference[0:205];
reg bin[0:205];
reg empty[0:205];


genvar i;

generate
	for(i = 0; i <= 100; i=i+1) begin: _reference
		always @(posedge clk) begin
			if(syn == 1'd1) begin
				if(i<2) reference[i] <= 1'd0;
				else reference[i] <= ((!bin[i-1])&(bin[i]));
			end
			else begin
				if(i == 100) reference[i] <= 1'd0;
				else reference[i] <= reference[i+1];
			end
		end
	end
endgenerate

generate
	for(i = 0; i <= 100; i=i+1) begin : _empty
		always @(posedge clk) begin
			if(syn == 1'd1) begin
				if(i == 0) empty[i] <= 1'd0;
				else empty[i] <= 1'd1;
			end
			else begin
				if(i == 0) empty[i] <= 1'd0;
				else empty[i] <= empty[i-1];
			end
		end
	end
endgenerate

generate
	for(i = 0; i <= 100; i=i+1) begin : _bin
		always @(posedge clk) begin
			if(syn == 1'd1) begin
				bin[i] <= 1'd0;
			end
			else begin
				bin[i] <= ((empty[i]==1'd1)?in:bin[i]);
			end
		end
	end
endgenerate


assign out = reference[0] | reference[1] | reference[2];
endmodule