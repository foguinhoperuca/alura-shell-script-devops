import re


def validate_cep(cep: str) -> bool:
    is_valid: bool = False
    pattern = r'^([A-Za-zÀ-ÿ|\d|@#$%^&+=] *)*, \w*, CEP [0-9]{5}-\d{3}$'

    matched = re.match(pattern, cep)
    is_valid = bool(matched)
    print(f'{matched=}')

    return is_valid


print(f'Rua das Flores, 123, CEP 60321-105 {validate_cep("Rua das Flores, 123, CEP 60321-105")}')
print(f'Avenida Brasil, 456A, CEP 16945-017 {validate_cep("Avenida Brasil, 456A, CEP 16945-017")}')
print(f'Travessa dos Santos, 101, CEP 12345-678 {validate_cep("Travessa dos Santos, 101, CEP 12345-678")}')
print(f'13 de Maio, 563, CEP 18090-398 {validate_cep("13 de Maio, 563, CEP 18090-398")}')
print(f'Rua #30, 78, CEP 18745-884 {validate_cep("Rua #30, 78, CEP 18745-884")}')
print(f'Rua sem número 17845-698 {validate_cep("Rua sem n?mero 17845-698")}')
print(f'Rua dos Sonhos, 12B, CEP 12345678 {validate_cep("Rua dos Sonhos, 12B, CEP 12345678")}')
