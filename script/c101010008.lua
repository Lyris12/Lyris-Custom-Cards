--PSYStream Lochness
local id,ref=GIR()
function ref.start(c)
--When this card is Special Summoned: You can add 1 "PSYStream" card from your Deck to your hand.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,id)
	e0:SetTarget(ref.thtg)
	e0:SetOperation(ref.thop)
	c:RegisterEffect(e0)
	--During either player's Main Phase, if this card was banished this turn: You can target 1 Spell/Trap Card your opponent controls; destroy it.
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetLabel(id)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e1:SetCountLimit(1,201010664)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(ref.con)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
	--This card can attack your opponent directly.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--If this card attacks directly, any battle damage your opponent takes becomes 800 if the amount is more than than 700.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(ref.rdcon)
	e3:SetOperation(ref.rdop)
	c:RegisterEffect(e3)
end
function ref.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil and ev>800
end
function ref.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,700)
end
function ref.thfilter(c)
	return c:IsSetCard(0x127) and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	local ef=e:GetHandler():GetReasonEffect()
	return ef and ef:GetHandler():IsSetCard(0x127) and e:GetHandler():GetFlagEffect(id)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function ref.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,ref.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
