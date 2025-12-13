package main
//$> odin run .
import "core:fmt"

main :: proc(){
    buffer := make([]u8, 4)                             // mem.alloc 
    fmt.printfln(
        "T: %d bytes | size_of: %d bytes | len: %d ", 
        size_of(u8), size_of(buffer),len(buffer))
    buffer[0] = 1
    buffer[1] = 2
    buffer[3] = 4
    for i in 0..< len(buffer) {                         
        fmt.printfln("buffer[%d] = %d", i, buffer[i])
    }
    delete(buffer)                                      // free memory.
    // buffer[0] = 111
    fmt.printfln("use after free: %d", buffer[3])

}
