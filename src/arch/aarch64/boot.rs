use core::{arch::global_asm, panic::PanicInfo, ptr};

global_asm!(include_str!("boot.s"));

#[no_mangle]
pub extern "C" fn rust_main() -> ! {
    let hello = b"Hello, world!";
    for byte in hello {
        unsafe {
            ptr::write_volatile(0x0900_0000 as *mut u8, *byte);
        }
    }
    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
