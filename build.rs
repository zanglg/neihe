fn main() {
    #[cfg(target_arch = "aarch64")]
    println!("cargo:rerun-if-changed=src/arch/aarch64/kernel.ld");
}
