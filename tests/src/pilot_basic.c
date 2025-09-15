#include <pilot/base.h>
#include <stdio.h>
#include <litmus/tests.h>

TEST_BEGIN(sample_test)
    const char* version = get_version();
    ASSERT(version != NULL, "Version string is not NULL");
    printf("Pilot version: %s\n", version);
TEST_END

RUN_TESTS(sample_test)
