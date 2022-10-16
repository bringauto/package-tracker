
extern int shared_out_of_dir_symlink();
extern int shared_with_soname();

int main() {

    return shared_out_of_dir_symlink() + shared_with_soname();

}