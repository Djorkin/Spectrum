class_name GSL

#var _preprocessor: GLSLPreprocessor
#var _parser: GLSLParser
#var _codegen: GLSLCodeGenerator
#
#func compile(source: String) -> Shader:
	#var tokens = _preprocessor.process(source)
	#var ast = _parser.parse(tokens)
	#return _codegen.generate(ast)
