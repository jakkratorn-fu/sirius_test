def check_duplicate_array(int_array):
    dup = {x for x in int_array if int_array.count(x) > 1}
    print("Here are all members that duplicated in list: ")
    print(dup)

check_duplicate_array([1,2,3,2,1,5,6,5,5,5])
