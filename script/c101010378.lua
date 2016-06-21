--Victorial Wield Ophichius
local id,ref=GIR()
function ref.start(c)
c:SetUniqueOnField(1,0,id)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1068)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(ref.target)
	e0:SetOperation(ref.operation)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(ref.con)
	e2:SetTarget(ref.tg)
	e2:SetOperation(ref.op)
	c:RegisterEffect(e2)
	--second effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() end)
	e3:SetCost(ref.cost)
	e3:SetTarget(ref.destg)
	e3:SetOperation(ref.desop)
	c:RegisterEffect(e3)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	if not ec then return end
	e:SetLabelObject(ec)
	return c:IsReason(REASON_LOST_TARGET) and bit.band(ec:GetReason(),0x21)==0x21
end
function ref.filter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsAbleToHand()
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil,tc:GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabelObject():GetLevel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_COST,nil)
end
function ref.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
