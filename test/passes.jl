using Test
using CompilerPluginTools

const GLOBAL_CONST = 2.0

@testset "inline_const" begin
    ci = @codeinfo begin
        Expr(:call, Core.Intrinsics.abs_float, 1.0)::Float64
        GlobalRef(Main, :GLOBAL_CONST)::Float64
        ReturnNode(SSAValue(1))::Float64
    end
    
    ir = Core.Compiler.inflate_ir(ci)
    ir = inline_const!(ir)
    @test ir.stmts[1][:inst] == 1.0
    @test ir.stmts[1][:type] == Const(1.0)
    @test ir.stmts[2][:inst] == 2.0
    @test ir.stmts[2][:type] == Const(2.0)        
end
