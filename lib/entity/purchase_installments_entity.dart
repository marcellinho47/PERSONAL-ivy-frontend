class PurchaseInstallmentsEntity {
  int? idPurchaseInstallments;
  int? installments;
  double? value;
  bool isPaid;

  PurchaseInstallmentsEntity({
    this.idPurchaseInstallments,
    this.installments,
    this.value,
    this.isPaid = false,
  });
}
