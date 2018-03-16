defmodule Tipalti.API.Payee do
  import SweetXml, only: [sigil_x: 2]

  @version "v7"

  use Tipalti.API,
    url: [
      sandbox: "https://api.sandbox.tipalti.com/#{@version}/PayeeFunctions.asmx",
      production: "https://api.tipalti.com/#{@version}/PayeeFunctions.asmx"
    ],
    standard_response: [
      ok_code: "OK",
      error_paths: [error_code: ~x"./errorCode/text()"s, error_message: ~x"./errorMessage/text()"os]
    ]

  # TODO: CancelInvoice

  # TODO: ClosePayeeAccount

  # TODO: CreatePayeeInfoAutoIdap

  # TODO: GetExtendedPayeeDetails

  # TODO: GetExtendedPayeeDetailsList

  # TODO: GetExtendedPODetails

  # TODO: GetExtendedPODetailsList

  # TODO: GetInvoicesPayableAmount

  def get_payee_details(idap) do
    run("GetPayeeDetails", [idap: idap], [:payer_name, idap, :timestamp], {
      ~x"//GetPayeeDetailsResult",
      name: ~x"./Name/text()"os,
      company_name: ~x"./CompanyName/text()"os,
      alias: ~x"./Alias/text()"os,
      address: ~x"./Address/text()"os,
      payment_method: ~x"./PaymentMethod/text()"os,
      email: ~x"./Email/text()"os,
      payment_terms_id: ~x"./PaymentTermsID/text()"os,
      payment_terms_name: ~x"./PaymentTermsName/text()"os
    })
  end

  # TODO: GetPayeeInvoiceList

  # TODO: GetPayeeInvoicesChangedSinceTimestamp

  # TODO: GetPayeePendingInvoiceTotal

  # TODO: GetPayeesChangedSinceTimestamp

  # TODO: GetPODetails

  def payee_payable(idap, amount \\ 100.0) do
    run(
      "PayeePayable",
      [idap: idap, amount: amount],
      [:payer_name, idap, :timestamp, {:float, amount}],
      {~x"//PayeePayableResult", reason: ~x"./s/text()"os, payable: ~x"./b/text()"b}
    )
  end

  def payee_payment_method(idap) do
    run(
      "PayeePaymentMethod",
      [idap: idap],
      [:payer_name, idap, :timestamp],
      {~x"//PayeePaymentMethodResult", payment_method: ~x"./s/text()"s}
    )
  end

  # TODO: PayeeStatusUpdate

  # TODO: PayeeUpdateAddress

  # TODO: PayeeUpdateEmail

  # TODO: PaymentsBetweenDates

  def update_or_create_payee_info(idap, params, opts) do
    with {:ok, skip_nulls} <- get_required_opt(opts, :skip_nulls),
         {:ok, override_payable_country} <- get_required_opt(opts, :override_payable_country) do
      run(
        "UpdateOrCreatePayeeInfo",
        [
          idap: idap,
          skipNulls: skip_nulls,
          overridePayableCountry: override_payable_country,
          item: [
            FirstName: params[:first_name],
            LastName: params[:last_name],
            Street1: params[:street1],
            Street2: params[:street2],
            City: params[:city],
            State: params[:state],
            Zip: params[:zip],
            Country: params[:country],
            Email: params[:email],
            Company: params[:company],
            Alias: params[:alias],
            PreferredPayerEntity: params[:preferred_payer_entity],
            ApAccountNumber: params[:ap_account_number],
            PaymentTermsID: params[:payment_terms_id]
          ]
        ],
        [:payer_name, idap, :timestamp, params[:street1]],
        {~x"//UpdateOrCreatePayeeInfoResult", :empty}
      )
    end
  end

  # TODO: UpdatePayeeCustomFields
end
