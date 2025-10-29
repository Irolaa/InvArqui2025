module AdderBit(input A, B, Ci, output Co, S);

	assign S = ~A& ~B& Ci | ~A& B& ~Ci | A& ~B& ~Ci | A& B& Ci;
	assign Co = ~A& B& Ci | A& ~B& Ci | A& B& ~Ci | A& B& Ci;

endmodule
	