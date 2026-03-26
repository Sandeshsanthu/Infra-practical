output "intancevariable"{
    description = "all is well"
    value = "ID-${aws_instance.myvm.id} | type:${aws_instance.myvm.instance_type}"
}