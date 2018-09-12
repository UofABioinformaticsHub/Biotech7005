package main

import (
	"bufio"
	"fmt"
	"log"
	"math/rand"
	"os"
	"strconv"
	"strings"
)

var option = []string{
	"hda5-1",
	"hda6-6",
	"hda9-1",
}

func main() {
	sc := bufio.NewScanner(os.Stdin)
	for sc.Scan() {
		fields := strings.Fields(sc.Text())
		if len(fields) == 0 {
			continue
		}
		if i := fields[0][0]; i < '0' || '9' < i {
			continue
		}
		a, err := strconv.Atoi(fields[0])
		if err != nil {
			log.Fatalf("failed to parse id: %v", err)
		}
		rand.Seed(int64(a))
		fmt.Printf("|a%s|%s|\n", fields[0], option[rand.Intn(3)])
	}
	err := sc.Err()
	if err != nil {
		log.Fatalf("error during scan: %v", err)
	}
}
