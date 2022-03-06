class SaleInstallmentsEntity {
  int? idSaleInstallments;
  int? installments;
  double? value;
  bool isPaid;

  SaleInstallmentsEntity({
    this.idSaleInstallments,
    this.installments,
    this.value,
    this.isPaid = false,
  });
}
