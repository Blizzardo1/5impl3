
int main(int argc, char* argv[]);

extern "C" void _begin()
{
    // call main
    main(0, nullptr);
    
    // halt
    while (true) { asm volatile("hlt"); }
}


int main(int argc, char *argv[])
{
    
    return 0;
}