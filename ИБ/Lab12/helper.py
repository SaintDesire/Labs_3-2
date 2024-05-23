class Helper:
    @staticmethod
    def get_open_text(filename):
        with open(filename, 'rb') as file:
            return file.read()

    @staticmethod
    def write_to_file(data, filename):
        with open(filename, 'wb') as file:
            file.write(data)