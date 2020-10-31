import sys

def main():
    return sys.argv[1].split(',')[0] > sys.argv[2].split(',')[0]


if __name__ == "__main__":
    main()