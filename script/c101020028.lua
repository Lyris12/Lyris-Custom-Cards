--Dragluo Prophet
local id,ref=GIR()
function ref.start(c)
	--You cannot Pendulum Summon monsters, except Dragon-Type monsters. This effect cannot be negated.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(aux.nfbdncon)
	e1:SetTarget(ref.splimit)
	c:RegisterEffect(e1)
	--You can target 1 Dragon-Type Xyz Monster in your Graveyard; Special Summon that target, and if you do, attach this card to it as an Xyz Material, but you cannot Pendulum Summon for the rest of this turn. You can only use this effect of "Dragluo Prophet" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(ref.psptg)
	e2:SetOperation(ref.pspop)
	c:RegisterEffect(e2)
	--If this card is Pendulum Summoned: Its controller cannot Special Summon monsters for the rest of the turn, except Dragon-Type monsters, also, you can target 1 Level 4 "Dragluo" monster you control; its Level becomes 8, until the end of this turn.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(ref.con)
	e4:SetCost(ref.pcost)
	e4:SetTarget(ref.tg)
	e4:SetOperation(ref.op)
	c:RegisterEffect(e4)
	--You can banish this card from your Graveyard, then target 1 Dragon-Type Xyz Monster in your Graveyard and up to 2 "Dragluo" monsters in your Graveyard; Special Summon the first target, and if you do, attach the second targets to it as Xyz Materials. You can only use each effect of "Dragluo Prophet" once per turn.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,201010194)
	e3:SetCost(ref.cost)
	e3:SetTarget(ref.sptg)
	e3:SetOperation(ref.spop)
	c:RegisterEffect(e3)
end
function ref.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_DRAGON) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function ref.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(ref.sumlimit)
	Duel.RegisterEffect(e1,c:GetControler())
end
function ref.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_DRAGON
end
function ref.pspfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.psptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.pspfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.pspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,ref.pspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function ref.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function ref.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x94b) and c:GetLevel()==4
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.spfilter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(ref.spfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,id)==1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,ref.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	else e:SetProperty(0) end
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e0:SetValue(8)
		tc:RegisterEffect(e0)
	end
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function ref.sfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_GRAVE,0,2,c,0x94b)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,ref.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	local og=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,2,2,tc,0x94b)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,og,2,0,0)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local ex,sg=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc=sg:GetFirst()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ex,og=Duel.GetOperationInfo(0,CATEGORY_LEAVE_GRAVE)
		Duel.Overlay(tc,og:Filter(Card.IsRelateToEffect,nil,e))
	end
end
