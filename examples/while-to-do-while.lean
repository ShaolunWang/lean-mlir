-- 1. start with while(c) { s; }.
-- 2. peel an iteration: if (c) { s; } while(c) { s; }
-- 3. move the loop into if: if (c) { s ; while(c) { s; } }
--   replace s; while(c) { s; } while do { s; } while(c)
-- 4. if (c) { do { s; } while(c) }

