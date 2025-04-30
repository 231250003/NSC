public interface RegisterAllocator {

    String allocate(String varName);
    int getStackSize();
}
