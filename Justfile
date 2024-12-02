build:
  swift build -c release

get_input day:
  #!/usr/bin/env bash
  day_formatted=$(printf "%02d" {{day}})
  file=input_${day_formatted}.txt
  mkdir -p inputs
  test -f ./inputs/$file && exit 0
  curl -s https://adventofcode.com/2024/day/{{day}}/input -H @headers.txt > ./inputs/$file

run day: (get_input day)
  swift run aoc2024 --day {{day}}

test filter="":
  #!/usr/bin/env bash
  if [[ -z "{{filter}}" ]]; then
    day=$(date +%d)
  else
    case "{{filter}}" in
    ''|*[!0-9]*) filter="{{filter}}";;  # Use the filter as is
    *) filter=$(printf "Day%02d" {{filter}})
    esac
  fi
  swift test --disable-xctest --filter $filter

watch filter="":
  fswatch -o ./Sources ./Tests | xargs -n1 -I{} bash -c "clear && printf '\033c'; just test {{filter}}"
