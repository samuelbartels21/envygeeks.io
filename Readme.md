# https://envygeeks.io

This is the source to my website.  The content license is proprietary, the design is MIT licensed.  This design is based on the Velox theme for Ghost with differences in how the HTML is done and a few tweaks to font and design... so if you use Ghost and you like my theme, make sure to check out the Velox theme.

## Building/Running

* Build: `docker-compose -f compose.yml run build`
* Production: `docker-compose -f compose.yml run production-build`
* Development: `docker-compose -f compose.yml run --service-ports development`
* Test: `docker-compose -f compose.yml run test`
