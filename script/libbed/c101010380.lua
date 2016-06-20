--Superpowered Metropolis - San Fransokyo
--超大国の都市ーサン・フランソ京
local id,ref=GIR()
function ref.start(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(ref.activate)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_BOTH_SIDE)
	e1:SetCountLimit(1,101010267+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(ref.tg)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EQUIP))
	e2:SetValue(aux.tgval)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_SEND_REPLACE)
	e6:SetTarget(ref.val)
	c:RegisterEffect(e6)
end
function ref.ecfilter(c,f)
	if not c:IsType(TYPE_EQUIP) then return false end
	if f==0 then return c:IsAbleToHand()
	else return c:IsAbleToGrave() and not Duel.IsExistingMatchingCard(Card.IsCode,tp,0xff,0,1,c,c:GetCode()) end
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,ref.ecfilter,tp,LOCATION_DECK,0,1,1,nil,0)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(1-tp,ref.ecfilter,tp,0,LOCATION_DECK,1,1,nil,0)
	local tc2=g2:GetFirst()
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	if tc1 then Duel.ConfirmCards(1-tp,tc1) end
	if tc2 then Duel.ConfirmCards(tp,tc2) end
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(ref.ecfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,1)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	e:SetLabelObject(sg1)
	Duel.SelectTarget(1-tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	local g=Duel.GetMatchingGroup(ref.ecfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,1)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	local sg1=e:GetLabelObject()
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg2=sg:GetFirst()
	if sg2==sg1 then sg2=sg:GetNext() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,ref.ecfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,1)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	local code=tc1:GetCode()
	Duel.SendtoGrave(g1,REASON_EFFECT)
	local eq1=Duel.CreateToken(tp,code)
	Duel.MoveToField(eq1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if not eq1:CheckEquipTarget(sg1) then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EQUIP_LIMIT)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		e0:SetValue(1)
		eq1:RegisterEffect(e0)
	end
	Duel.Equip(tp,eq1,sg1,true,true)
	local eq2=Duel.CreateToken(tp,code)
	Duel.MoveToField(eq2,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	if not eq2:CheckEquipTarget(sg2) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		eq2:RegisterEffect(e1)
	end
	Duel.Equip(1-tp,eq2,sg2,true,true)
	Duel.EquipComplete()
end
function ref.reptg(c)
	return c:GetEquipCount()~=0
end
function ref.val(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.reptg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c==Duel.GetFieldCard(tp,LOCATION_SZONE,5) end
	return true
end
